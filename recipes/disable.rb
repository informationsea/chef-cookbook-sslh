service 'sslh' do
  supports :status => true, :restart => true
  action   [:stop, :disable]
end
