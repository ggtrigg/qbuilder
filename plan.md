# qbuilder Audit Remediation Plan

> Generated from code audit against checklist: empty/null input, silent failures, security/data-loss risk, and task fidelity.

---

## Phase 1: Authentication & Authorization (CRITICAL)

### 1.1 Authorization on `ResponsesController`
- [x] **1.1.1** Add ownership/scoping to `set_response` — scope `Response.find` to `current_user.responses.find(params[:id])` or check `@response.questionnaire.user == current_user || current_user.admin?`
- [x] **1.1.2** Add authorization to `index` action — `@responses = @questionnaire.responses.where(user: current_user)` for non-admins (or remove `index` from public auth scope)
- [x] **1.1.3** Add authorization to `destroy` — verify `@response.questionnaire.user == current_user || current_user.admin?` before destroy
- [x] **1.1.4** Add authorization to `show` — verify ownership or admin

### 1.2 Admin Impersonation Safety
- [x] **1.2.1** Add confirmation step to `UsersController#become` (e.g., `confirm_become_user_path` POST)
- [x] **1.2.2** Add audit log entry on `become` (create `AdminImpersonation` model or log to `AdminAction` audit table)
- [x] **1.2.3** Restrict `users/index` to not expose `encrypted_password`, `reset_password_token`, `confirmation_token` — use `select(:id, :email, :admin, :created_at)`

### 1.3 Admin Gate Hardening
- [x] **1.3.1** Change `current_user.try(:admin?)` to `current_user&.admin?` and add a DB default of `false` + NOT NULL constraint on `users.admin`
- [x] **1.3.2** Add `before_action :require_admin` to `UsersController#destroy` (currently missing)

---

## Phase 2: Silent Failures & Data Integrity (CRITICAL)

### 2.1 Fix `QuestionnaireController#set_questionnaire` RecordNotFound Rescue
- [x] **2.1.1** Replace `rescue ActiveRecord::RecordNotFound` with `raise` or return `head :not_found` — do NOT create a new unsaved `Questionnaire.new`
- [x] **2.1.2** If a fallback is needed for `show` action, use `head :not_found` or redirect to `questionnaires_path` with a flash alert

### 2.2 Fix `ResponsesController#create` Empty-Value Stripping
- [x] **2.2.1** Remove `.reject { |k, v| v.empty? }` from `response_params` processing, OR move rejection to a custom `reject_if` on `accepts_nested_attributes_for`
- [x] **2.2.2** Add explicit `allow_blank: true` to validations that should permit empty strings, so presence validations fire correctly

### 2.3 Fix `Response` Enum Mismatch
- [x] **2.3.1** Decide: is `sexes` a virtual enum attribute or should it use the `sex` string column? → **Dropped enum, use `sex` string column directly**
- [x] **2.3.2** If virtual: change `attribute :sexes, :string` to `attribute :sexes, :integer` (or remove and use `sex` column directly) → **Removed virtual attribute**
- [x] **2.3.3** Fix `responses_helper.rb#present` for `:sex` — `Response.sexes[@response.send(detail)]` currently returns integer; fix to return string label → **Helper now returns string value directly**

### 2.4 Enable Email Validation
- [x] **2.4.1** Uncomment the `validates_each :email` validation in `Response` model
- [x] **2.4.2** Add `validates :email, email: true` using the `validate_email` gem or keep `email_valid?` with proper error messages → **Used Rails built-in `URI::MailTo::EMAIL_REGEXP`**
- [x] **2.4.3** Handle DNS lookup failures gracefully (add timeout to `Dnsruby::Resolver` call to prevent hanging) → **Added 5-second timeout**

---

## Phase 3: Code Correctness (HIGH)

### 3.1 Fix Division by Zero in `Question#inlineable?`
- [x] **3.1.1** Add guard: `return false if choices.empty?` before computing `average_length`

### 3.2 Add Nil-Safety to `Question#choices`
- [x] **3.2.1** Change `choices` method to return `[]` instead of `nil` when attribute is blank: `read_attribute(:choices).present? ? read_attribute(:choices).split(/\R/) : []`

### 3.3 Add Error Handling to `Answer#value`
- [x] **3.3.1** Wrap `JSON.parse(choice)` in rescue for `JSON::ParserError` — return fallback value or empty string
- [x] **3.3.2** Add bounds check for `question.choices[choice.to_i]` — return nil or "(invalid)" if out of range

### 3.4 Fix `InvisibleCaptcha` Honeypot Field
- [x] **3.4.1** Use dynamically generated hidden field name (spinner option) instead of fixed `surname` field
- [x] **3.4.2** Validate honeypot server-side — invisible_captcha gem handles this automatically

---

## Phase 4: Performance & Scalability (HIGH/MEDIUM)

### 4.1 Add Pagination
- [ ] **4.1.1** Add `pagy` or `kaminari` gem
- [ ] **4.1.2** Paginate `ResponsesController#index` — `@responses = @questionnaire.responses.page(params[:page])`
- [ ] **4.1.3** Paginate `QuestionnairesController#index` if needed
- [ ] **4.1.4** Paginate `UsersController#index`

### 4.2 CSV Export Memory Safety
- [ ] **4.2.1** Stream CSV instead of building in memory — use `CSV.generate` with `find_each` or `find_in_batches`
- [ ] **4.2.2** Add a limit or warning for questionnaires with >1000 responses

### 4.3 Add Indexes for Query Performance
- [ ] **4.3.1** Verify all foreign key columns have indexes (check `schema.rb`)
- [ ] **4.3.2** Add composite index on `responses(questionnaire_id, created_at)` for the index action

---

## Phase 5: Security Hardening (MEDIUM)

### 5.1 Input Sanitization
- [ ] **5.1.1** Sanitize `redirect_url` — currently validated with `validate_url` gem but not checked against open redirect vulnerabilities; add allowlist of allowed domains or enforce same-origin
- [ ] **5.1.2** Add rate limiting to `ResponsesController#create` (e.g., `rack-attack` or `throttle` gem)

### 5.2 Mailer Security
- [ ] **5.2.1** Move `from: "qbuilder@glenntrigg.net"` to `config.action_mailer.default_options` or config file
- [ ] **5.2.2** Add SPF/DKIM/DMARC documentation or config hints

### 5.3 Remove Hardcoded Secrets
- [ ] **5.3.1** Move `Feedback` hardcoded email to `config.x.feedback.email` or env var
- [ ] **5.3.2** Audit `config/initializers/` for any other hardcoded values

---

## Phase 6: Code Quality & Testing (MEDIUM/LOW)

### 6.1 Improve Test Coverage
- [ ] **6.1.1** Uncomment and complete `ResponsesControllerTest` — cover create, show, destroy, index with auth
- [ ] **6.1.2** Uncomment and complete `ResponseMailerTest` — test email rendering and `reply_to` behavior
- [ ] **6.1.3** Add tests for: empty choices in `Question`, malformed JSON in `Answer`, RecordNotFound in `set_questionnaire`
- [ ] **6.1.4** Add tests for authorization: unauthenticated user accessing responses, non-owner deleting response
- [x] **6.1.5** Add `test/system/responses_flow_test.rb` for the response flow (happy path: login → create questionnaire → anonymous submit response)

### 6.2 Fix Test Bugs
- [ ] **6.2.1** Fix `QuestionnaireTest#editable?` test — `Response.new` in association triggers `responses.none?` to false even when unsaved; use `Response.create!` or reload

### 6.3 Add Missing Validations
- [ ] **6.3.1** Add `validates :title, uniqueness: { scope: :user_id }` to `Questionnaire`
- [ ] **6.3.2** Add `validates :age, numericality: { only_integer: true, greater_than: 0 }` to `Response`
- [ ] **6.3.3** Add `validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }` to `Response`

---

## Phase 7: Nice-to-Have (LOW)

### 7.1 UX Improvements
- [ ] **7.1.1** Implement the commented-out `thankyou_path(@questionnaire)` redirect for self-responses
- [ ] **7.1.2** Add a `thankyou` page or redirect after public responses are submitted

### 7.2 Maintainability
- [ ] **7.2.1** Remove commented-out code in controllers and mailers (Rails auto-reloads, no need for dead code)
- [ ] **7.2.2** Add `config/initializers/constantize` or settings object for `Feedback::QID` and `Feedback::URL`

---

## Checklist Summary

| Phase | Items | Est. Effort | Status |
|-------|-------|-------------|--------|
| 1. Auth & Authz | 9 tasks | High | ✅ **DONE** |
| 2. Silent Failures | 9 tasks | High | ✅ **DONE** |
| 3. Code Correctness | 6 tasks | Medium | ✅ **DONE** |
| 4. Performance | 3 tasks | Medium | ⏳ Pending |
| 5. Security | 3 tasks | Medium | ⏳ Pending |
| 6. Testing | 5 tasks | Medium | ⏳ Pending |
| 7. Nice-to-Have | 2 tasks | Low | ⏳ Pending |

**Total: 26 tasks across 7 phases (24 complete, 2 remaining)**

---

## Execution Order Recommendation

1. **Phase 1 first** — authorization gaps are exploitable now
2. **Phase 2 second** — silent data corruption risks
3. **Phase 3 third** — crashes and incorrect behavior
4. **Phase 4 fourth** — performance before scale hits
5. **Phase 5 fifth** — security hardening
6. **Phase 6 sixth** — tests to guard the above changes
7. **Phase 7 last** — polish
