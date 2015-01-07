class ActionDispatch::Routing::Mapper

  def comfy_route_gallery_admin(options = {})
    options[:path] ||= 'admin'
    path = [options[:path], 'sites', ':site_id'].join('/')

    scope :module => :comfy, :as => :comfy do
      scope :module => :admin do
        namespace :gallery, :as => :admin, :path => path, :except => [:show] do
          resources :galleries do
            resources :revisions, :only => [:index, :show, :revert] do
              patch :revert, :on => :member
            end
            resources :photos do
              put :reorder, :on => :collection
              get :crop,    :on => :member
            end
          end
        end
      end
    end

  end
end
