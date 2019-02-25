#===============================================================================
# ** Module Win32 - Handles numerical based data.
#-------------------------------------------------------------------------------
# Author    Ruby
# Version   1.8.1
#===============================================================================
SDK.log("Win32", "Ruby", "1.8.1", "Unknown")

#-------------------------------------------------------------------------------
# Begin SDK Enabled Check
#-------------------------------------------------------------------------------
if SDK.state('Win32') == true
  
module Win32

  #--------------------------------------------------------------------------
  # ● Retrieves data from a pointer.
  #--------------------------------------------------------------------------
  def copymem(len)
    buf = "\0" * len
    Win32API.new("kernel32", "RtlMoveMemory", "ppl", "").call(buf, self, len)
    buf
  end
  
end

# Extends the numeric class.
class Numeric
  include Win32
end

# Extends the string class.
class String
  include Win32
end
#==============================================================================
#End
#==============================================================================

end