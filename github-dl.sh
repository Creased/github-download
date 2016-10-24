# Usage : github-dl <email|username> <token|password> <orgs|users> <entity>

function github-dl() {
    if (( $# == 4 )); then
        usr=${1}
        tok=${2}
        type=${3}
        ent=${4}
        for repo in $(curl -u "${usr}:${tok}" -s "https://api.github.com/${type}/${ent}/repos?per_page=200" | sed -n -e 's/\s*"clone_url":\s"\(.*\)",/\1/p' | sort | uniq); do (
            prj=$(printf "${repo}" | sed 's/^[^ ]*\/\(.*\)\.git$/\1/');
            rls=$(curl -u "${usr}:${tok}" -s "https://api.github.com/repos/${ent}/${prj}/releases" | sed -n -e 's/\s*"url":\s"\(.*\)",/\1/p' | head -n1);
            objs=$(curl -u "${usr}:${tok}" -s "${rls}" | sed -n -e 's/\s*"browser_download_url":\s"\(.*\)"/\1/p');
            git clone "${repo}" &>/dev/null && printf "\033[1;32m[+]\033[0m " || printf "\033[1;31m[!]\033[0m ";
            printf "${repo} => $(pwd)/${prj}\n";
            for obj in ${objs}; do (
                file=$(printf "${obj}" | sed 's/^[^ ]*\///');
                mkdir -p $(pwd)/${prj}/.repo/;
                mv -f $(pwd)/${prj}/!(.repo|.|..) -t $(pwd)/${prj}/.repo/;
                mkdir -p $(pwd)/${prj}/release/;
                mv $(pwd)/${prj}/{.,}repo/;
                curl -u "${usr}:${tok}" -s "${repo}" 2>/dev/null >$(pwd)/${prj}/release/${file} && printf "\033[1;32m[+]\033[0m " || printf "\033[1;31m[!]\033[0m ";
                printf "${obj} => $(pwd)/${prj}/release/${file}\n";
            ); done
        ); done
    else
            printf "Illegal number of parameters\n";
    fi
}
