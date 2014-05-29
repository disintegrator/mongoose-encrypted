bcrypt = require 'bcrypt'
_ = require 'lodash'
EncryptionStrategy = require './Base'

module.exports = class BcryptStrategy extends EncryptionStrategy
    @method: 'bcrypt'

    getPreambleSegments: -> null

    transformValue: (value) ->
        salt = bcrypt.genSaltSync @options.saltRounds, @options.seedLength
        bcrypt.hashSync value, salt

    @compare: (input, encryptedValue, callback) ->
        hash = encryptedValue.split('$$').slice(1).join '$$'
        bcrypt.compare input, hash, callback
