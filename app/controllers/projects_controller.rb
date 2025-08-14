require 'zip'
require 'tempfile'
require 'open-uri'
require 'yaml'

class ProjectsController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :authenticate_user!
  before_action :set_project, only: %i[edit update destroy export]

  layout "two_thirds", only: %i[index new edit]

  # GET /projects
  def index
    @projects = current_user.projects.all.order(:title)
  end

  # GET /projects/1
  def show
    redirect_to project_posts_path(project_id: params[:id])
  end

  # GET /projects/new
  def new
    @project = current_user.own_projects.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = current_user.own_projects.new(project_params)
    if @project.save
      redirect_to @project, notice: "Your design history has been created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Your changes have been saved"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy!
    redirect_to projects_url, notice: "Your design history has been deleted"
  end

  # GET /projects/1/export
  def export
    temp_zip = Tempfile.new(["#{@project.subdomain}-export", '.zip'])

    begin
      Zip::File.open(temp_zip.path, Zip::File::CREATE) do |zipfile|
        posts_json_content = {
          "layout" => "post",
          "permalink" => "{{ page.filePathStem | replace('posts/', '') }}/"
        }.to_json

        zipfile.get_output_stream("posts/posts.json") { |f| f.write(posts_json_content) }

        @project.posts.where(published: true).order(:published_at).each do |post|
          filename_date = post.published_at&.strftime('%Y-%m-%d') || Date.current.strftime('%Y-%m-%d')
          markdown_filename = "posts/#{filename_date}-#{post.slug}.md"
          markdown_content = generate_markdown_for_post(post, zipfile)
          zipfile.get_output_stream(markdown_filename) { |f| f.write(markdown_content) }
        end
      end

      zip_data = File.read(temp_zip.path)
      send_data zip_data,
                filename: "#{@project.subdomain}-export-#{Date.current}.zip",
                type: 'application/zip',
                disposition: 'attachment'
    ensure
      temp_zip.close
      temp_zip.unlink
    end
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :title,
      :subdomain,
      :description,
      :theme,
      :related_links,
      :comments_enabled
    )
  end

  def generate_markdown_for_post(post, zipfile)
    frontmatter = {
      'title' => post.title,
      'description' => truncate_description(post.body),
      'date' => post.published_at&.strftime('%Y-%m-%d') || Date.current.strftime('%Y-%m-%d')
    }

    screenshots = []
    image_dir = "images/#{post.slug}"

    post.ordered_images.each_with_index do |image, index|
      original_filename = image.filename.to_s
      extension = File.extname(original_filename)
      base_name = image.custom_metadata&.dig('title') || File.basename(original_filename, extension)
      sanitized_name = sanitize_filename(base_name)
      image_filename = sprintf("%02d-%s%s", index + 1, sanitized_name, extension)

      screenshot_entry = {
        'text' => image.custom_metadata&.dig('title') || base_name,
        'src' => image_filename
      }

      if image.custom_metadata&.dig('alt_text').present?
        screenshot_entry['alt'] = image.custom_metadata['alt_text']
      end

      if image.custom_metadata&.dig('caption').present?
        screenshot_entry['caption'] = image.custom_metadata['caption']
      end

      screenshots << screenshot_entry

      if image.blob.service.name == :local
        image_path = ActiveStorage::Blob.service.path_for(image.blob.key)
        zipfile.add("#{image_dir}/#{image_filename}", image_path)
      else
        image.blob.open do |tempfile|
          zipfile.get_output_stream("#{image_dir}/#{image_filename}") do |f|
            f.write(tempfile.read)
          end
        end
      end
    end

    if screenshots.any?
      frontmatter['screenshots'] = { 'items' => screenshots }
    end

    frontmatter['tags'] = []

    markdown = "---\n"
    markdown += frontmatter.to_yaml.lines[1..].join  # Skip the first line which is "---"
    markdown += "---\n\n"

    if post.body.present?
      markdown += post.body
      markdown += "\n\n"
    end

    if post.related_links.present?
      markdown += "## Related links\n\n"
      markdown += post.related_links
      markdown += "\n"
    end

    markdown
  end

  def truncate_description(text)
    return '' if text.blank?

    plain_text = text.gsub(/[#*_`\[\]()]/, '').strip
    plain_text.truncate(160)
  end

  def sanitize_filename(name)
    name.gsub(/[^0-9A-Za-z.\-_]/, '-')
        .gsub(/--+/, '-')
        .gsub(/^-|-$/, '')
        .downcase
  end
end
