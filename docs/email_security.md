# Email Security Configuration

This document describes the email security setup for qbuilder.

## Current Configuration

### Mailer Defaults
- **From address**: Configured via `config.action_mailer.default_options.from` in `config/application.rb`
- **Source**: `Rails.application.credentials.dig(:mailer, :default_from)` or `ENV["MAILER_DEFAULT_FROM"]`
- **Default fallback**: `qbuilder@glenntrigg.net`

### Delivery Method
- **Development**: Test delivery (emails stored in `ActionMailer::Base.deliveries`)
- **Production**: SMTP via `ironman.gatewaybbs.com.au` (configured in credentials)

## SPF Record

Add a TXT record to your domain's DNS:

```
Type: TXT
Host: @ (or your domain)
Value: v=spf1 include:_spf.ironman.gatewaybbs.com.au ~all
```

If using a different SMTP provider, replace with their SPF include mechanism.

## DKIM Setup

### Generate DKIM Keys

```bash
# Generate private key (2048-bit)
openssl genrsa -out dkim_private.pem 2048

# Extract public key
openssl rsa -in dkim_private.pem -pubout -out dkim_public.pem
```

### Add DKIM Public Key to DNS

Create a TXT record:
```
Type: TXT
Host: default._domainkey.yourdomain.com
Value: v=DKIM1; k=rsa; p=YOUR_PUBLIC_KEY_HERE
```

The public key is the base64 content from `dkim_public.pem` (without the header/footer lines, on one line).

### Configure DKIM in Rails

Add `dkim` gem to Gemfile and run `bundle install`.

```ruby
# config/initializers/dkim.rb
Dkim::domain      = 'yourdomain.com'
Dkim::selector    = 'default'
Dkim::private_key = Rails.application.credentials.dig(:dkim, :private_key)
```

## DMARC Record

Add a TXT record to your domain's DNS:

```
Type: TXT
Host: _dmarc.yourdomain.com
Value: v=DMARC1; p=quarantine; rua=mailto:dmarc@yourdomain.com; ruf=mailto:dmarc@yourdomain.com; fo=1
```

### DMARC Policy Options
- `p=none` - Monitor only (recommended for initial setup)
- `p=quarantine` - Mark suspicious emails as spam
- `p=reject` - Reject emails that fail DMARC

### DMARC Tags Explained
- `v=DMARC1` - Version
- `p=quarantine` - Policy for organizational domain
- `rua=mailto:...` - Aggregate reports
- `ruf=mailto:...` - Forensic reports
- `fo=1` - Generate forensic reports for any failure

## Testing Your Configuration

### Quick Tests

```bash
# Check SPF
dig TXT yourdomain.com

# Check DKIM
dig TXT default._domainkey.yourdomain.com

# Check DMARC
dig TXT _dmarc.yourdomain.com
```

### Online Tools
- [MXToolbox SPF Check](https://mxtoolbox.com/spf.aspx)
- [MXToolbox DKIM Check](https://mxtoolbox.com/dkim.aspx)
- [MXToolbox DMARC Check](https://mxtoolbox.com/dmarc.aspx)
- [Mail-Tester.com](https://www.mail-tester.com/) - Send a test email for comprehensive scoring

## Production Checklist

- [ ] SPF record published and valid
- [ ] DKIM keys generated and DNS record published
- [ ] DKIM private key added to Rails credentials
- [ ] DMARC record published with `p=quarantine` (start with `p=none` for testing)
- [ ] Test email sent and passes SPF/DKIM/DMARC checks
- [ ] Monitor DMARC aggregate reports for issues
- [ ] After 30 days of clean reports, consider changing DMARC policy to `p=reject`

## Troubleshooting

### Emails going to spam
1. Check SPF/DKIM/DMARC alignment
2. Verify IP reputation
3. Check for spam trigger words in content
4. Ensure proper List-Unsubscribe headers

### DKIM failing
1. Verify private key matches public key in DNS
2. Check selector matches DNS record
3. Ensure no whitespace/newlines in DNS TXT value

### DMARC failing
1. Ensure SPF and DKIM both pass and align with From domain
2. Check `p=` policy is appropriate for current stage