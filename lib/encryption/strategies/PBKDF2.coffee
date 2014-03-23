crypto = require 'crypto'
_ = require 'lodash'
EncryptionStrategy = require './base'

module.exports = class PBKDF2Strategy extends EncryptionStrategy
    @method: 'pbkdf2'

    getPreambleSegments: ->
        [@options.iterations, @options.keyLength, @options.saltLength]

    parsePreamble: (rawPreamble, callback) ->
        rawSegments = rawPreamble?.split ':'
        return callback?('bad encryption preamble') if rawSegments?.length isnt 4

        # slice off the name of the crypto (we don't need it at this point)
        parsedSegments = _.map rawSegments.slice(1), (rawSegment) -> parseInt rawSegment, 10
        return callback?('bad encryption preamble') if _.any parsedSegments, _.isNaN
        callback? null, parsedSegments

    transformValue: (value) ->
        salt = crypto.pseudoRandomBytes(@options.saltLength).toString('hex').toUpperCase()
        key = crypto.pbkdf2Sync value, salt, @options.iterations, @options.keyLength
        hash = new Buffer(key, 'binary').toString 'hex'
        "#{salt}.#{hash}"

    compare: (input, encryptedValue, callback) ->
        parts = encryptedValue.split '$$'
        parameters = parts[0]?.split(':')?.slice 1  # slice off the crypto name
        saltedHash = parts[1]?.split '.'
        salt = saltedHash?[0]
        hash = saltedHash?[1]
        return callback?(null, 'wrong') if not input or not salt or not hash
        @parsePreamble parts[0], (err, res) ->
            return callback?(err) if err?
            crypto.pbkdf2 input, salt, res[0], res[1], (err, res) ->
                return callback?(err) if err?
                inputHash = new Buffer(res, 'binary').toString 'hex'
                callback? null, inputHash is hash
