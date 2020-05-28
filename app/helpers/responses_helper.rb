module ResponsesHelper
  def present(detail)
    case detail.to_sym
    when :address
      @response.send(detail).gsub(/\R/, ', ')
    when :sex
      Response.sexes[@response.send(detail)]
    else
      @response.send(detail)
    end
  end
end
