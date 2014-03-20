PBKDF2Strategy = require './PBKDF2'

strategies = {}

strategies[PBKDF2Strategy.method] = PBKDF2Strategy

module.exports = strategies
