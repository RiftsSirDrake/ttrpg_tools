# Load the Rails application.
require_relative "application"

require 'aws-sdk-secretsmanager'
require 'base64'

def get_secret()
  secret_name = "rds-db-credentials/cluster-3HASICN5EOURSFHHBW5PF5UXPA/adminotron"
  region_name = "us-east-1"

  client = Aws::SecretsManager::Client.new(region: region_name)

  # In this sample we only handle the specific exceptions for the 'GetSecretValue' API.
  # See https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
  # We rethrow the exception by default.
  begin
    get_secret_value_response = client.get_secret_value(secret_id: secret_name)
  rescue Aws::SecretsManager::Errors::DecryptionFailure => e
    # Secrets Manager can't decrypt the protected secret text using the provided KMS key.
    # Deal with the exception here, and/or rethrow at your discretion.
    raise
  rescue Aws::SecretsManager::Errors::InternalServiceError => e
    # An error occurred on the server side.
    # Deal with the exception here, and/or rethrow at your discretion.
    raise
  rescue Aws::SecretsManager::Errors::InvalidParameterException => e
    # You provided an invalid value for a parameter.
    # Deal with the exception here, and/or rethrow at your discretion.
    raise
  rescue Aws::SecretsManager::Errors::InvalidRequestException => e
    # You provided a parameter value that is not valid for the current state of the resource.
    # Deal with the exception here, and/or rethrow at your discretion.
    raise
  rescue Aws::SecretsManager::Errors::ResourceNotFoundException => e
    # We can't find the resource that you asked for.
    # Deal with the exception here, and/or rethrow at your discretion.
    raise
  else
    # This block is ran if there were no exceptions.

    # Decrypts secret using the associated KMS key.
    # Depending on whether the secret is a string or binary, one of these fields will be populated.
    if get_secret_value_response.secret_string
      secret = get_secret_value_response.secret_string
    else
      secret = Base64.decode64(get_secret_value_response.secret_binary)
    end
    
    hash = JSON.parse(secret)
  end
end

# Initialize the Rails application.
if Rails.env.production?
  db_secret = get_secret()
  ENV['DB_HOST'] = db_secret['host']
  ENV['DB_USER'] = db_secret['username']
  ENV['DB_PASS'] = db_secret['password']
  ENV['DB_PORT'] = db_secret['port'].to_s
end

Rails.application.initialize!