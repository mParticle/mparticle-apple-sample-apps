
/* eslint-disable no-template-curly-in-string */
module.exports = {
    branches: ['main'],
    tagFormat: 'v${version}',
    plugins: [
        [
            '@semantic-release/commit-analyzer',
            {
                preset: 'angular',
            },
        ],
        [
            '@semantic-release/release-notes-generator',
            {
                preset: 'angular',
            },
        ],
        [
            '@semantic-release/changelog',
            {
                changelogFile: 'CHANGELOG.md',
            },
        ],
        [
            '@semantic-release/exec',
            {
                prepareCmd: 'sh ./scripts/release.sh ${nextRelease.version}',
            },
        ],
        [
            '@semantic-release/github',
            {
            },
        ],
        [
            '@semantic-release/git',
            {
                assets: ['HiggsShopSampleApp/Info.plist', 'CHANGELOG.md'],
                message:
                    'chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}',
            },
        ],
    ],
};