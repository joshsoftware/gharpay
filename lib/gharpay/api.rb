module Gharpay
  class Base
    include HTTParty
  
    format :xml
    if Rails.env == 'production'
      base_uri "http://webservices.gharpay.in/rest/GharpayService"
    else
      base_uri "http://services.gharpay.in/rest/GharpayService"
    end

    def initialize(username, password)
      @creds = {"username" => username, "password" => password }
    end
    
    # Validates whether the location with this pincode is serviced by Gharpay
    def valid_pincode?(zip)
      res = self.class.get("/isPincodePresent", :query => {:pincode => zip}, :headers => @creds)
      eval(res['isPincodePresentPresentResponse']['result'])
    rescue 
      return false
    end

    # Creates order with Gharpay
    def create_order(order) 
      options = {:body => order.to_xml(:root => "transaction"), :headers => @creds.merge('Content-Type' => 'application/xml')}
      res = self.class.post("/createOrder", options)
      return res['createOrderResponse']['orderID'] unless res['createOrderResponse']['errorMessage']
      res['createOrderResponse']['errorMessage']
    rescue
      return nil 
    end    
  
    # This method cancels the complete order.
    def cancel_order(cancel_order)
      options = {:body => cancel_order.to_xml(:root => "cancelOrder"), :headers => @creds.merge('Content-Type' => 'application/xml')}
      res = self.class.post("/cancelOrder", options)
      return res['cancelOrderResponse']['result'] unless res['cancelOrderResponse']['errorMessage']
      res['cancelOrderResponse']['errorMessage']
    rescue
      return false
    end
    
    # TODO: check output
    def view_details(order_id)
      res = self.class.get("/viewOrderDetails", :query => {:orderID => order_id}, :headers => @creds)
      res['viewOrderDetailsResponse'] unless res['viewOrderDetailsResponse']['errorMessage']
      res['viewOrderDetailsResponse']['errorMessage']
    rescue
      return nil  
    end  
    
    # This method returns the status of the order
    def view_order_status(order_id)
      res = self.class.get("/viewOrderStatus", :query => {:orderID => order_id}, :headers => @creds)
      res['viewOrderStatusResponse']['orderStatus']
    rescue
      return nil
    end   
    
    # This method returns a list of cities currently being served by Gharpay in an array
    def city_list
      res = self.class.get("/getCityList", :headers => @creds)
      res['getCityListResponse']['city']
    rescue
      return nil  
    end  
    
    # This method returns a list of pincodes in a city in an array 
    def pincodes_in_city(city)
      res = self.class.get("/getPincodesInCity", :query => {:cityName => city}, :headers => @creds)
      return res['getPincodesInCityResponse']['pincode'] unless res['getPincodesInCityResponse']['errorMessage']
      res['getPincodesInCityResponse']['errorMessage']
    rescue
      return nil
    end  
  end
end
