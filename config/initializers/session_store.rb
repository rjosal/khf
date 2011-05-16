# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_khf_session',
  :secret      => '268e1eb0a022e0df59c2e2b28e0e12503b4ee9c2e1bdd80ca23cc354ff5076dcc3dac3b7813888016cd8dc448f51470a6627a89b330914167d846eacecf5f1a7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
