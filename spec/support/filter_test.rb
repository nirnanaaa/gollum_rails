class FilterTest < Gollum::Filter
  def extract(data)
    data
  end
  def process(data)
    "#{data}-append"
  end
end

