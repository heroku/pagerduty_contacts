require 'json'

class Contact
  def self.all
    users1 = `curl -g -X GET -H "Authorization: Token token=#{ENV["TOKEN"]}" "https://#{ENV["DOMAIN"]}.pagerduty.com/api/v1/users?include[]=contact_methods&include[]=notification_rules&limit=100"`
    users2 = `curl -g -X GET -H "Authorization: Token token=#{ENV["TOKEN"]}" "https://#{ENV["DOMAIN"]}.pagerduty.com/api/v1/users?include[]=contact_methods&include[]=notification_rules&limit=100&offset=100"`
    users = JSON.parse(users1)["users"] + JSON.parse(users2)["users"]

    users.map do |u|
      {name: u["name"],
      phone: !!u["contact_methods"].detect{|m| m["type"] == 'phone'},
      email: !!u["contact_methods"].detect{|m| m["type"] == 'email'},
      sms: !!u["contact_methods"].detect{|m| m["type"] == 'SMS'},
      push: !!u["contact_methods"].detect{|m| m["type"] == 'push_notification'}
      }
    end
  end
end
