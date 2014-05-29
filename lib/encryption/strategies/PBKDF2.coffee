crypto = require 'crypto'
_ = require 'lodash'
EncryptionStrategy = require './Base'

module.exports = class PBKDF2Strategy extends EncryptionStrategy
    @method: 'pbkdf2'

    getPreambleSegments: ->
        [@options.iterations, @options.keyLength, @options.saltLength]

    transformValue: (value) ->
        salt = crypto.pseudoRandomBytes(@options.saltLength).toString('hex').toUpperCase()
        key = crypto.pbkdf2Sync value, salt, @options.iterations, @options.keyLength
        hash = new Buffer(key, 'binary').toString 'hex'
        "#{salt}.#{hash}"

    @compare: (input, encryptedValue, callback) ->
        parts = encryptedValue.split '$$'
        parameters = parts[0]?.split(':')?.slice 1  # slice off the crypto name
        saltedHash = parts[1]?.split '.'
        salt = saltedHash?[0]
        hash = saltedHash?[1]
        parsedSegments = _.map parameters, (rawSegment) -> parseInt rawSegment, 10

        return callback?('bad hash') if not input or not salt or not hash
        return callback?('bad encryption preamble') if (parsedSegments?.length isnt 3) or
            _.any parsedSegments, _.isNaN

        crypto.pbkdf2 input, salt, parsedSegments[0], parsedSegments[1], (err, res) ->
            return callback?(err) if err?
            inputHash = new Buffer(res, 'binary').toString 'hex'
            callback? null, inputHash is hash
