PBKDF2Strategy = require './PBKDF2'
BcryptStrategy = require './Bcrypt'

strategies = {}

strategies[PBKDF2Strategy.method] = PBKDF2Strategy
strategies[BcryptStrategy.method] = BcryptStrategy

module.exports = strategies
