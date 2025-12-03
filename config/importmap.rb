# Pin npm packages by running ./bin/importmap

pin "application"
pin "trix-editor-overrides"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "sass" # @1.94.2
pin "buffer" # @6.0.3
pin "immutable" # @5.1.4
pin "process" # @2.1.0
pin "fontawesome" # @5.6.3
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@stimulus-components/sortable", to: "@stimulus-components--sortable.js" # @5.0.3
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.12
pin "sortablejs" # @1.15.6
pin "nouislider" # @15.8.1
pin "trix" # @2.1.15
pin "base64-js" # @1.5.1
pin "ieee754" # @1.2.1
pin "bootstrap", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
enable_integrity!
pin_all_from "app/javascript/controllers", under: "controllers", integrity: true
pin_all_from "app/javascript/channels", under: "channels", integrity: true
pin "@fortawesome/fontawesome-free", to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-free@7.1.0/js/all.js" # @7.1.0
