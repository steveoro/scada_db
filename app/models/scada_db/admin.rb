module ScadaDb


=begin

= Admin model

  - version:  0.0.3
  - author:   Steve A.

=end
  class Admin < ActiveRecord::Base
    # Avoid module namespace in table names:
    self.table_name = "admins"

    # Include default devise modules. Others available are:
    # :registerable, :recoverable, :rememberable, :validatable,
    # :confirmable,  and :omniauthable
    devise :database_authenticatable,
           :trackable, :lockable, :timeoutable
  end
end
