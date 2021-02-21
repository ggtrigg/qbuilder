module EmailAddressUtil

  def valid_address?(email_address)
    domain = begin
      Mail::Address.new(email_address).domain
    rescue => exception
      nil
    end

    is_good = if domain
      begin
        res = Dnsruby::Resolver.new
        resp = res.query(domain, 'MX')
        resp.answer.count > 0
      rescue
        false
      end
    else
      false
    end
  end

end