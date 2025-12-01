# Pin npm packages by running ./bin/importmap

pin "application"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "bootstrap", preload: true # @5.3.8
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
pin "sass" # @1.94.2
pin "buffer" # @6.0.3
pin "immutable" # @5.1.4
pin "process" # @2.1.0
pin "fontawesome" # @5.6.3
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@stimulus-components/sortable", to: "@stimulus-components--sortable.js" # @5.0.3
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.12
pin "sortablejs" # @1.15.6
pin "nouislider" # @15.8.1
pin "trix" # @2.1.15
pin "base64-js" # @1.5.1
pin "ieee754" # @1.2.1
