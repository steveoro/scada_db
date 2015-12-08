module ScadaDb


=begin

= User model

  - version:  0.0.3
  - author:   Steve A.

=end
  class User < ActiveRecord::Base
    # Avoid module namespace in table names:
    self.table_name = "users"

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :confirmable, :lockable,
           :recoverable, :rememberable, :trackable, :validatable
  end
end
