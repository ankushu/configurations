# Reference
https://docs.github.com/en/rest/teams/members#add-or-update-team-membership-for-a-user

# Examples
- To add/update a user to a team with the default role 'member'

gh_api --method PUT orgs/{org}/teams/{team}/memberships/{userName} #gh_api is alias set in .zhsrc
e.g. gh_api --method PUT orgs/it-devops/teams/dcx-productivity-team/memberships/fn-ln #default role member
e.g. gh_api --method PUT orgs/it-devops/teams/dcx-productivity-team/memberships/fn-ln  -f role='maintainer'  #setting role maintainer

