# coding: utf-8

Pod::Spec.new do |s|
    s.name          = 'HIDataStoreManager'
    s.version       = '1.0.0'
    s.license       = { :type => 'MIT', :file => 'LICENSE' }
    s.homepage      = 'github.com/kshuin/HIDateStoreManager'
    s.authors       = { 'kshuin' => 'koichi.skt@gmail.com' }
    s.summary       = 'HIDataStoreManager is NSManagedObjectContext wrapper library for using CoreData under multi-threaded environment.'
    s.source        = { :git => 'https://github.com/kshuin/HIDateStoreManager.git',
                        :tag => 'v1.0.0' }
    s.source_files  = "HIDataStoreManager/*.{h, m}"
    s.framework     = 'CoreData'
    s.requires_arc  = true
end
