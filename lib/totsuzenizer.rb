# -*- coding: utf-8 -*-
require 'totsuzenizer/filter'

module Totsuzenizer

  TOTSUZENSHI_AA = "\n＿人人人人人＿\n＞ 突然の死 ＜\n￣ＹＹＹＹＹ￣"

  class << self
    def root
      File.join(File.expand_path(File.dirname(__FILE__)), '..')
    end
  end
end

#alias for Totsuzenizer
T = Totsuzenizer
