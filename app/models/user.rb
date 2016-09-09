class User < ApplicationRecord
  attr_accessor :password
  before_save :encrypt_password
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,  :presence => {:message => "Поле 'E-mail' не должно быть пустым"},
				    :format => {:with => email_regex, :message => "Поле 'E-mail' не соответсвует формату адреса электронной почты 'user@mail-provider.ru'"},
				    :uniqueness => {:case_sensitive => false, :message => "E-mail уже используется"},
		  			:allow_nil => true
          
  validates :email,   :presence => true

  validates :password,   :presence     => true,
						:confirmation => true,
                         :length       => { :within => 6..40 }
   
   
   
   def self.groups 
     [
       {id: 1, name: 'admin', full_name: 'Администратор'},
       {id: 2, name: 'editor', full_name: 'Редактор'},
       {id: 3, name: 'authorized', full_name: 'Зарегистрированный'},
       {id: 4, name: 'deleted', full_name: 'Удаленный'}
     ]
   end

   def group
     get_group
   end                       
   def has_password?(submitted_password)
     encrypted_password == encrypt(submitted_password)
   end

     def self.authenticate(email, submitted_password)
     user = find_by_email(email)
     return nil  if user.nil?
     return user if user.has_password?(submitted_password)
   end

  def self.authenticate_with_salt(id, cookie_salt)
       user = find_by_id(id)
       (user && user.salt == cookie_salt) ? user : nil
     end  

   private
   def get_group
     g = User.groups.last
     User.groups.each do |g|
       return g if g[:id] == self.user_type_id
     end
     return g
   end
   def encrypt_password
     self.salt = make_salt if new_record?
     self.encrypted_password = encrypt(password)
   end	

   def encrypt(string)
     secure_hash("#{salt}--#{string}")
   end

   def make_salt 
     secure_hash("#{Time.now.utc}--#{password}")
   end

   def secure_hash(string)
     Digest::SHA2.hexdigest(string)
   end
end
