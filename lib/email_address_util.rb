module EmailAddressUtil
  def valid_address?(email_address)
    domain = begin
      Mail::Address.new(email_address).domain
    rescue => exception
      nil
    end

    return false unless domain

    begin
      res = Dnsruby::Resolver.new
      res.query_timeout = 5
      resp = res.query(domain, "MX")
      resp.answer.count > 0
    rescue Dnsruby::ResolvTimeout, Dnsruby::ServFail, Dnsruby::NXDomain, Dnsruby::FormErr
      # DNS unavailable or domain doesn't exist - don't reject, just skip DNS check
      true
    rescue
      # Any other error - skip DNS check
      true
    end
  end
end