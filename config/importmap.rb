# Pin npm packages by running ./bin/importmap

pin "application"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "trix" # @2.1.8
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "jquery" # @3.7.1
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.esm.min.js", preload: true # @5.3.3
pin "@popperjs/core", to: "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/esm/popper.min.js" # @2.11.8
pin "sass" # @1.81.0
pin "buffer" # @2.1.0
pin "immutable" # @5.0.3
pin "process" # @2.1.0
pin "fontawesome" # @5.6.3
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@stimulus-components/sortable", to: "@stimulus-components--sortable.js" # @5.0.1
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.8
pin "sortablejs" # @1.15.6
pin "nouislider" # @15.8.1
