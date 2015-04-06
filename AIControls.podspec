Pod::Spec.new do |s|

s.name              = 'AIControls'
s.version           = '0.1.3'
s.summary           = 'Set of Custom Controls for iOS Swift'
s.homepage          = 'https://github.com/anasiqbal/AIControls'
s.license           = {
	:type => 'MIT',
	:file => 'LICENSE'
}
s.author            = {
	'Anas Iqbal' => 'anasiqbal@outlook.com'
}
s.source            = {
	:git => 'https://github.com/anasiqbal/AIControls.git',
	:tag => s.version.to_s
}
s.ios.deployment_target = '7.0'
s.platform = :ios, '7.0'
s.source_files      = 'Controls/**/*.{swift}'
s.requires_arc      = true

end