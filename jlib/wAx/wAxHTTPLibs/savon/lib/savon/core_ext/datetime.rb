
class DateTime

  # Returns the DateTime as an xs:dateTime formatted String.
  def to_soap_value
    strftime WAx::WAxHTTPLibs::Savon::SOAP::DateTimeFormat
  end

  alias_method :to_soap_value!, :to_soap_value

end 