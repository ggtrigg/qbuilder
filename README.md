# qbuilder - A questionnaire builder

## Features

* Each login (email address) has their own collection of questionnaires (and responses)

* Responder personal details (but not questionnaire answers) are stored encrypted in the database

* Questionnaire descriptions can be rich text and include images (courtesy of ActionText)

* Question types can be Yes/No, True/False, single line text, multi line text. Multiple choice is being considered.

A running qbuilder installation can be found at https://www.glenntrigg.net/qbuilder and a sample questionnaire form at
https://www.glenntrigg.net/qbuilder/questionnaires/31QhZ3/responses/new .

## Installation

* Rails version - 6.0.3

* System dependencies
  - bootstrap 4.4
  - font-awesome-rails 4.7
  - hashid-rails 1.4
  - devise
  - json
  - attr_encrypted 3.1

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
  response:
    name_key: 256-bit-random-key
    address_key: 256-bit-random-key
    email_key: 256-bit-random-key
    phone_key: 256-bit-random-key
    age_key: 256-bit-random-key
    sex_key: 256-bit-random-key
  ```
  I used the command `ruby -r securerandom -e '6.times { puts SecureRandom.alphanumeric(32) }'` to generate the 6 keys. These are used by `attr_encrypted` for encrypting the responder personal data.

  Run `bin/yarn install` to install all javascript dependencies.

* Database creation

  Use the `config/database.yml` file to set up the database the way you like.

* Database initialization
  - `bin/rails db:create`
  - `bin/rails db:migrate`

* How to run the test suite

  TODO

* Services (job queues, cache servers, search engines, etc.)

  None at this stage

* Deployment instructions

  TODO

## TODO

  * Multiple choice type questions

  * Paginating the list of responses for a questionnaire

  * Exporting response data
