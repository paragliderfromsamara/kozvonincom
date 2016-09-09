class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  def loc_name(locale = :ru)
    (locale == :com) ? com_name : ru_name
  end
  def loc_desc(locale = :ru)
    (locale == :com) ? com_description : ru_description
  end
  def loc_content(locale = :ru)
    (locale == :com) ? com_content : ru_content
  end
  def merged_name
    merge_mult_local_text(com_name, ru_name)
  end
  def merged_content
    merge_mult_local_text(com_content, ru_content)
  end
  def merged_description
    merge_mult_local_text(com_description, ru_description)
  end
  def split_by_locale(t) # текст должен выглядеть вот так: "русский {english}"
    reg = /\{(.+)\} ?/
    v = {com: '', ru: ''}
    return v if t.blank?
    i = t.index(reg)
    if !i.nil?
      t.gsub(reg) do |t|
        v[:com] = $1
      end
      v[:ru] = t[0..i-1] if i > 0
    else
      v[:ru] = t
    end
    return v
  end
  
  private
  
  def merge_mult_local_text(com, ru)
    v = "#{ru}"
    v += "{#{com}}" if !com.blank?
    return v
  end
end
