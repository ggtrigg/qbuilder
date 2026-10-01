module ResponsesHelper
  def present(detail)
    case detail.to_sym
    when :address
      @response.send(detail).gsub(/\R/, ", ")
    else
      @response.send(detail)
    end
  end
end