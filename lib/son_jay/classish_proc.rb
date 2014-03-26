module SonJay
  class ClassishProc < Proc
    alias new call
  end
end
