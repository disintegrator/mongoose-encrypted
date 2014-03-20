strategies = require '../encryption/strategies'

module.exports = (schema) ->
    schema.methods.checkEncrypted = (fieldName, value, callback) ->
        fieldValue = @[fieldName]
        return callback?(null, false) if not fieldValue
        fieldProperties = schema.path(fieldName)
        encryptionMethod = fieldProperties?.options.method
        Strategy = strategies[encryptionMethod]
        return callback?(null, false) if not Strategy
        strategy = new Strategy fieldProperties?.options.encryptOptions
        strategy.compare value, fieldValue, callback
