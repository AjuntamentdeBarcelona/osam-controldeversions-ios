Pod::Spec.new do |s|
    s.name         = 'VersionControl'
    s.version      = '2.1'
    s.license      = { :type => 'BSD' }
    s.homepage     = 'https://gitlab.dtibcn.cat/osam_ios/control_versions_ios.git'
    s.summary      = 'VersionControl offers helper methods to alert the user when there is a new version of the app'
    s.author =
    {
        'Salvador Martin' => 'salvador.martin@worldline.com'
    }
    
    s.source  = {
        :git => "https://gitlab.dtibcn.cat/osam_ios/control_versions_ios.git", :tag => "2.1"
    }

    s.source_files = "T21AlertComponent/T21AlertComponent/**/*.{h,m}", "T21AlertComponent/T21AlertComponent/categories/**/*.{h,m}"
    s.requires_arc = true
    s.ios.deployment_target = '9.0'
end