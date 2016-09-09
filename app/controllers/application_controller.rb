class ApplicationController < ActionController::Base
  include SessionsHelper
  include ApplicationHelper
  
  protect_from_forgery with: :exception
  
  before_action :set_locale
 
  def set_locale
    I18n.locale = extract_locale_from_tld || I18n.default_locale
  end
 
  # Получаем локаль из домена верхнего уровня или возвращаем nil, если такая локаль недоступна
  # Вам следует поместить что-то наподобие этого:
  #   127.0.0.1 application.com
  #   127.0.0.1 application.it
  #   127.0.0.1 application.pl
  # в ваш файл /etc/hosts, чтобы попробовать это локально
  def extract_locale_from_tld
    parsed_locale = request.host.split('.').last
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
end
