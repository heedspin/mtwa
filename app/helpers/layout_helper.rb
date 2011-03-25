module LayoutHelper
  def title(txt)
    content_for(:title, txt)
    txt
  end
  def meta_title(txt)
    content_for(:meta_title, txt)
    txt
  end
  def meta_description(txt)
    content_for(:meta_description, txt)
    txt
  end
  def meta(cm)
    unless cm.is_a?(ContentModule)
      cm = content_module(cm)
    end
    title cm.title if cm.has_title?
    meta_title cm.meta_title if cm.has_meta_title? and cm.meta_title.present?
    meta_description cm.meta_description if cm.has_meta_description?
    cm
  end
end
