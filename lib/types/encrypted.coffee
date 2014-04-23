_ = require 'lodash'
mongoose = require 'mongoose'
strategies = require '../encryption/strategies'


class Encrypted extends mongoose.SchemaTypes.String
    defaults:
        minLength: 8
    method: (strategyKey) ->
        defaults = @defaults
        path = @path
        @set (val, self, init) ->
            options = _.extend {}, defaults, self.options
            minLength = options.minLength
            val = if val then val?.trim() else val
            return '' unless !!val
            if val?.length < minLength
                return @invalidate path, "Field must be at least #{minLength} characters."

            Strategy = strategies[strategyKey]
            throw new Error('unrecognised encryption method') if not Strategy?
            strategy = new Strategy options.encryptOptions
            strategy.encrypt val

module.exports = (mongoose) ->
    mongoose.SchemaTypes.Encrypted = Encrypted
    mongoose.Types.Encrypted = Encrypted
