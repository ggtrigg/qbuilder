# qbuilder - A questionnaire builder

## Features

* Each login (email address) has their own collection of questionnaires (and responses)

* Responder personal details (but not questionnaire answers) are stored encrypted in the database

* The form used for responding to a questionnaire has built in spam protection

* Questionnaire descriptions can be rich text and include images (courtesy of ActionText)

* Question types can be Yes/No, True/False, single line text, multi line text, multiple choice (single or any), and score (e.g. on a scale from 1 to 10)

A running qbuilder installation can be found at https://qbuilder.glenntrigg.net and a sample questionnaire form at
https://qbuilder.glenntrigg.net/31QhZ3 .

## Installation

* Rails version - 8.0.1

* System dependencies
  - bootstrap 5.3.3
  - hashid-rails 1.4.1
  - devise
  - json

* Configuration

  Use `bin/rails credentials:edit` to add the following entries:

  ```
  database:
    host: hostname
    database: db_name
    username: db_username
    password: db_password
  smtp:
    user_name: your-smtp-username
    password: your-smtp-password
    port: smtp-port
  active_record_encryption:
    primary_key: ...
    deterministic_key: ...
    key_derivation_salt: ...
  ```

  The active_record_encryption keys can be generated using the `bin/rails db:encryption:init` command.

  Run `bin/yarn install` to install all javascript/css dependencies.

* Database creation

  Use the `config/database.yml` file to set up the database the way you like.

* Database initialization
  - `bin/rails db:create`
  - `bin/rails db:migrate`

* How to run the test suite

  bin/rails test

* Services (job queues, cache servers, search engines, etc.)

  None at this stage

* Deployment instructions

  TODO

## TODO

  * User account administration

  * Paginating the list of responses for a questionnaire

  * More test cases
