# Pin npm packages by running ./bin/importmap

pin "application"
pin "trix-editor-overrides"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "sass" # @1.100.0
pin "@fortawesome/fontawesome-free", to: "@fortawesome--fontawesome-free.js" # @7.2.0
pin "buffer" # @6.0.3
pin "immutable" # @5.1.5
pin "process" # @2.1.0
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@stimulus-components/sortable", to: "@stimulus-components--sortable.js" # @5.0.3
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.13
pin "sortablejs" # @1.15.7
pin "nouislider" # @15.8.1
pin "base64-js" # @1.5.1
pin "ieee754" # @1.2.1
pin "bootstrap", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
enable_integrity!
pin_all_from "app/javascript/controllers", under: "controllers", integrity: true
pin_all_from "app/javascript/channels", under: "channels", integrity: true
