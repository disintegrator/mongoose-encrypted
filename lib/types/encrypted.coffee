mongoose = require 'mongoose'
strategies = require '../encryption/strategies'


class Encrypted extends mongoose.SchemaTypes.String
    method: (strategyKey) ->
        @set (val, self) ->
            return '' if not val
            Strategy = strategies[strategyKey]
            throw new Error('unrecognised encryption method') if not Strategy?
            strategy = new Strategy self.options.encryptOptions
            strategy.encrypt val

module.exports = (mongoose) ->
    mongoose.SchemaTypes.Encrypted = Encrypted
    mongoose.Types.Encrypted = Encrypted
