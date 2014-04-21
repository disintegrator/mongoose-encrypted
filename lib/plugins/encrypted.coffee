strategies = require '../encryption/strategies'

module.exports = (schema) ->
    schema.methods.checkEncrypted = (fieldName, value, callback) ->
        fieldValue = @get fieldName
        return callback?(null, false) if not fieldValue
        encryptionMethod = (fieldValue.split('$$')[0] or '').split(':')[0]
        Strategy = strategies[encryptionMethod]
        return callback?('unrecognised encryption method') if not Strategy
        Strategy.compare value, fieldValue, callback
