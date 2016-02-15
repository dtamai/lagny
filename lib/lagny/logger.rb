module Lagny
  begin
    logger_type = case LAGNY_ENV
                  when "test" then { :type => :file, :path => "/dev/null" }
                  else { :type => :stdout }
                  end

    Logger = LogStashLogger.new logger_type
  end
end
