{
  title: "Canvas",
  connection: {
    fields: [
      {
        name: "domain",
        hint: "abc.instructure.com"
      },
      {
        name: "developer_key_id",
        hint: "1000000000000000000"
      },
      {
        name: "developer_key",
        control_type: "password"
      }
    ],
    authorization: {
      type: "oauth2",
      authorization_url: lambda do |connection|
        params = {
          response_type: "code",
          redirect_uri: "https://www.workato.com/oauth/callback",
          client_id: connection["developer_key_id"],
          client_secret: connection["developer_key"]
        }.to_param
        "https://#{connection['domain']}/login/oauth2/auth?" + params
      end,
      acquire: lambda do |connection, auth_code, _redirect_uri|
        response = post("https://#{connection['domain']}/login/oauth2/token").
          payload(
            code: auth_code,
            grant_type: "authorization_code",
            redirect_uri: "https://www.workato.com/oauth/callback",
            client_id: connection["developer_key_id"],
            client_secret: connection["developer_key"])
      end,
      refresh_on: 401,
      refresh: lambda do |connection, refresh_token|
        post("https://#{connection['domain']}/login/oauth2/token").
          headers('Authorization': "Bearer #{connection['access_token']}").
          payload(
            grant_type: "refresh_token",
            refresh_token: refresh_token,
            client_id: connection["developer_key_id"],
            client_secret: connection["developer_key"])
      end,
      apply: lambda do |connection, access_token|
        headers('Authorization': "Bearer #{access_token}")
      end
    }
  },
  object_definitions: {
    course: {
      preview: lambda do |connection|
        get("https://#{connection['domain']}/api/v1/courses").first
      end,
      fields: lambda do |object_definitions|
        [
          {
            name: "id",
            type: :integer,
            control_type: :number
          },
          {
            name: "sis_course_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "integration_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "name",
            type: :string,
            control_type: :text
          },
          {
            name: "course_code",
            type: :string,
            control_type: :text
          },
          {
            name: "workflow_state",
            type: :string,
            control_type: :select,
            pick_list: "course_workflow_states"
          },
          {
            name: "account_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "root_account_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "enrollment_term_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "grading_standard_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "start_at",
            type: :datetime,
            control_type: :timestamp
          },
          {
            name: "end_at",
            type: :datetime,
            control_type: :timestamp
          },
          {
            name: "locale",
            type: :string,
            control_type: :text
          },
          {
            name: "total_students",
            type: :integer,
            control_type: :number
          },
          {
            name: "calendar",
            type: :object,
            properties: [
              {
                name: "ics",
                type: :string,
                control_type: :url
              }
            ]
          },
          {
            name: "enrollments",
            type: :array,
            of: :object,
            properties: object_definitions["enrollment"]
          },
          {
            name: "default_view",
            type: :string,
            control_type: :select,
            pick_list: "default_views"
          },
          {
            name: "syllabus_body",
            type: :string,
            control_type: "text-area"
          },
          {
            name: "needs_grading_count",
            type: :integer,
            control_type: :number
          },
          {
            name: "term",
            type: :object,
            properties: object_definitions["enrollment_term"]
          },
          {
            name: "course_progress",
            type: :object,
            properties: [
              {
                name: "requirement_count",
                type: :integer,
                control_type: :number
              },
              {
                name: "requirement_completed_count",
                type: :integer,
                control_type: :number
              },
              {
                name: "next_requirement_url",
                type: :string,
                control_type: :url
              },
              {
                name: "completed_at",
                type: :datetime,
                control_type: :timestamp
              }
            ]
          },
          {
            name: "apply_assignment_group_weights",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "permissions",
            type: :object,
            properties: [
              {
                name: "create_discussion_topic",
                type: :boolean,
                control_type: :checkbox
              },
              {
                name: "create_announcement",
                type: :boolean,
                control_type: :checkbox
              },
            ]
          },
          {
            name: "is_public",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "is_public_to_auth_users",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "public_syllabus",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "public_syllabus_to_auth",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "public_description",
            type: :string,
            control_type: :text
          },
          {
            name: "storage_quota_mb",
            type: :integer,
            control_type: :number
          },
          {
            name: "storage_quota_used_mb",
            type: :integer,
            control_type: :number
          },
          {
            name: "hide_final_grades",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "license",
            type: :string,
            control_type: :text
          },
          {
            name: "allow_student_assignment_edits",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "allow_wiki_comments",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "allow_student_forum_attachments",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "open_enrollment",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "self_enrollment",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "restrict_enrollments_to_course_dates",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "course_format",
            type: :string,
            control_type: :text
          },
          {
            name: "access_restricted_by_date",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "time_zone",
            type: :string,
            control_type: :text
          }
        ]
      end
    },
    enrollment: {
      preview: lambda do |connection|
        get("https://#{connection['domain']}/api/v1/users/1/enrollments").first
      end,
      fields: lambda do |object_definitions|
        [
          {
            name: "id",
            type: :integer,
            control_type: :number
          },
          {
            name: "course_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "sis_course_id",
            type: :string,
            control_type: :text
          },
          {
            name: "course_integration_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "section_integration_id",
            type: :string,
            control_type: :text
          },
          {
            name: "sis_account_id",
            type: :string,
            control_type: :text
          },
          {
            name: "sis_section_id",
            type: :string,
            control_type: :text
          },
          {
            name: "sis_user_id",
            type: :string,
            control_type: :text
          },
          {
            name: "enrollment_state",
            type: :string,
            control_type: :text
          },
          {
            name: "limit_privileges_to_course_section",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "sis_import_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "root_account_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "type",
            type: :array,
            control_type: :select,
            pick_list: "enrollment_type"
          },
          {
            name: "user_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "associated_user_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "role",
            type: :string,
            control_type: :text
          },
          {
            name: "role_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "created_at",
            type: :datetime,
            control_type: :timestamp
          },
          {
            name: "updated_at",
            type: :datetime,
            control_type: :timestamp
          },
          {
            name: "start_at",
            type: :datetime,
            control_type: :timestamp
          },
          {
            name: "end_at",
            type: :datetime,
            control_type: :timestamp
          },
          {
            name: "last_activity_at",
            type: :datetime,
            control_type: :timestamp
          },
          {
            name: "total_activity_time",
            type: :integer,
            control_type: :number
          },
          {
            name: "html_url",
            type: :string,
            control_type: :url
          },
          {
            name: "grades",
            type: :string,
            control_type: :url
          },
          {
            name: "computed_current_score",
            type: :number,
            control_type: :number
          },
          {
            name: "computed_final_score",
            type: :number,
            control_type: :number
          },
          {
            name: "computed_current_score",
            type: :number,
            control_type: :number
          },
          {
            name: "computed_final_score",
            type: :number,
            control_type: :number
          },
          {
            name: "has_grading_periods",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "totals_for_all_grading_periods_option",
            type: :boolean,
            control_type: :checkbox
          },
          {
            name: "current_grading_period_title",
            type: :string,
            control_type: :text
          },
          {
            name: "current_grading_period_id",
            type: :integer,
            control_type: :number
          },
          {
            name: "current_period_computed_current_score",
            type: :number,
            control_type: :number
          },
          {
            name: "current_period_computed_final_score",
            type: :number,
            control_type: :number
          },
          {
            name: "current_period_computed_current_grade",
            type: :string,
            control_type: :text
          },
          {
            name: "current_period_computed_final_grade",
            type: :string,
            control_type: :text
          }
        ]
      end
    },
    enrollment_term: {
      preview: lambda do |connection|
        get("https://#{connection['domain']}/api/v1/accounts/1/terms").first
      end,
      fields: lambda do |object_definitions|
        [
          {
            name: "id",
            type: :integer,
            control_type: :number
          },
          {
            name: "name",
            type: :string,
            control_type: :text
          },
          {
            name: "start_at",
            type: :datetime,
            control_type: :timestamp
          },
          {
            name: "end_at",
            type: :datetime,
            control_type: :timestamp
          }
        ]
      end
    }
  },
  test: lambda do |connection|
    get("https://#{connection['domain']}/api/v1/courses")
  end,
  triggers: {
    new_enrollment_term: {
      input_fields: lambda do
        [
          {
            name: "account_id",
            control_type: :number,
            optional: false
          },
          {
            name: "workflow_state",
            type: :string,
            control_type: :select,
            pick_list: "term_workflow_states",
            optional: false
          },
          {
            name: "overrides",
            type: :boolean,
            control_type: :checkbox,
            optional: true,
            hint: "Include overridden term dates"
          },
          {
            name: 'since',
            type: :timestamp
          }
        ]
      end,
      poll: lambda do |connection, input, last_created_since|
        created_since = last_created_since || input['since'] || Time.now
        enrollment_terms = get("https://#{connection['domain']}/api/v1/accounts/#{input['account_id']}/terms").
          payload("include[]": input["overrides"] ? "overrides" : "",
                  "workflow_state[]": (input["workflow_state"] or "")).
          request_format_www_form_urlencoded["enrollment_terms"].
          select { |term| term["created_at"] >= created_since }.
          sort_by { |term| term["created_at"] }
        next_created_since = enrollment_terms.last["created_at"] unless enrollment_terms.blank?
        {
          events: enrollment_terms,
          next_poll: next_created_since
        }
      end,
      dedup: lambda do |enrollment_term|
        enrollment_term["id"]
      end,
      output_fields: lambda do |object_definitions|
        object_definitions["enrollment_term"]
      end
    }
  },
  actions: {
    list_courses: {
      input_fields: lambda do
        [
          {
            name: "user_id",
            optional: false
          }
        ]
      end,
      execute: lambda do |connection, input|
        {
          "courses": get("https://#{connection['domain']}/api/v1/users/#{input['user_id']}/courses")
        }
      end,
      output_fields: lambda do |object_definitions|
        [
          {
            name: "courses",
            type: :array,
            of: :object,
            properties: object_definitions["course"]
          }
        ]
      end
    },
    get_course: {
      input_fields: lambda do
        [
          {
            name: "course_id",
            control_type: :number,
            optional: false
          },
          {
            name: "account_id",
            control_type: :number,
            optional: true
          },
          {
            name: "all_courses",
            control_type: :checkbox,
            optional: true,
            hint: "Include recently deleted courses"
          },
          {
            name: "permissions",
            control_type: :checkbox,
            optional: true,
            hint: "What permissions the user has for this course"
          },
          {
            name: "observed_users",
            control_type: :checkbox,
            optional: true,
            hint: "Observed users in the enrollments"
          },
          {
            name: "course_image",
            control_type: :checkbox,
            optional: true,
            hint: "Available when there is a course image and the course image feature flag has been enabled"
          }
        ]
      end,
      execute: lambda do |connection, input|
        include_fields = [
          "all_courses",
          "permissions",
          "observed_users",
          "course_image"].
          select{|v| input[v]}.
          join(",")
        if input["account_id"].present?
          get("https://#{connection['domain']}/api/v1/accounts/#{input['account_id']}/courses/#{input['course_id']}").
            payload("include[]": include_fields).
            request_format_www_form_urlencoded
        else
          get("https://#{connection['domain']}/api/v1/courses/#{input['course_id']}").
            payload("include[]": include_fields).
            request_format_www_form_urlencoded
        end
      end,
      output_fields: lambda do |object_definitions|
        {
          name: "course",
          type: :object,
          properties: object_definitions["course"]
        }
      end
    },
    list_enrollment_terms: {
      input_fields: lambda do
        [
          {
            name: "account_id",
            control_type: :number,
            optional: false
          },
          {
            name: "workflow_state",
            type: :string,
            control_type: :select,
            pick_list: "term_workflow_states",
            optional: false
          },
          {
            name: "overrides",
            type: :boolean,
            control_type: :checkbox,
            optional: true,
            hint: "Include overridden term dates"
          }
        ]
      end,
      execute: lambda do |connection, input|
        get("https://#{connection['domain']}/api/v1/accounts/#{input['account_id']}/terms").
          payload("include[]": input["overrides"] ? "overrides" : "",
                  "workflow_state[]": (input["workflow_state"] or "")).
          request_format_www_form_urlencoded
      end,
      output_fields: lambda do |object_definitions|
        [
          {
            name: "enrollment_terms",
            type: :object,
            properties: object_definitions["enrollment_term"]
          }
        ]
      end
    }
  },
  pick_lists: {
    course_workflow_states: lambda do |connection|
      [
        ["Unpublished", "unpublished"],
        ["Available", "available"],
        ["Completed", "completed"]
      ]
    end,
    term_workflow_states: lambda do |connection|
      [
        ["Active", "active"],
        ["Deleted", "deleted"],
        ["All", "all"]
      ]
    end,
    default_views: lambda do |connection|
      [
        ["Feed", "feed"],
        ["Wiki", "wiki"],
        ["Modules", "modules"],
        ["Assignments", "assignments"],
        ["Syllabus", "syllabus"]
      ]
    end,
    enrollment_type: lambda do |connection|
      [
        ["Unpublished", "StudentEnrollment"],
        ["Available", "TeacherEnrollment"],
        ["Completed", "TaEnrollment"],
        ["Completed", "DesignerEnrollment"],
        ["Completed", "ObserverEnrollment"]
      ]
    end
  }
}

