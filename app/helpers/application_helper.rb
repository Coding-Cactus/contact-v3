module ApplicationHelper
  def resize(img_url, size=50)
    "#{img_url.split('.')[-1] == 'svg' ? '' : "https://replit.com/cdn-cgi/image/width=#{size}/"}#{img_url}"
  end
end
