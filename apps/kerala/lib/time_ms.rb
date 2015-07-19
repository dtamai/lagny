module Kerala
  class TimeMs < Virtus::Attribute
    def coerce(time)
      (time.to_f * 1_000).to_i
    end
  end
end
