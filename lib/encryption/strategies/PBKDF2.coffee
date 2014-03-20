crypto = require 'crypto'
EncryptionStrategy = require './base'

module.exports = class PBKDF2Strategy extends EncryptionStrategy
    @method: 'pbkdf2'

    getPreambleSegments: ->
        [@options.iterations, @options.keyLength, @options.saltLength]

    transformValue: (value) ->
        salt = crypto.pseudoRandomBytes(@options.saltLength).toString('hex').toUpperCase()
        key = crypto.pbkdf2Sync value, salt, @options.iterations, @options.keyLength
        hash = new Buffer(key, 'binary').toString 'hex'
        "#{salt}.#{hash}"

    compare: (input, encryptedValue, callback) ->
        saltedHash = encryptedValue.split('$$')?[1]?.split('.')
        salt = saltedHash?[0]
        hash = saltedHash?[1]
        return false if not input or not salt or not hash
        crypto.pbkdf2 input, salt, @options.iterations, @options.keyLength, (err, res) ->
            return callback?(err) if err?
            inputHash = new Buffer(res, 'binary').toString 'hex'
            callback? null, inputHash is hash
