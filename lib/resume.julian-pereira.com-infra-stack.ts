import { StackProps, Stack, aws_codebuild as codebuild, SecretValue } from 'aws-cdk-lib';
import { Construct } from 'constructs';

export interface ResumeJulianPereiraComInfraStackProps extends StackProps {
    readonly githubTokenSsmParameterName: string;
    readonly repo: string;
    readonly owner: string;
}

export class ResumeJulianPereiraComInfraStack extends Stack {
    constructor(scope: Construct, id: string, props: ResumeJulianPereiraComInfraStackProps) {
        super(scope, id, props);

        const githubToken = new codebuild.GitHubSourceCredentials(this, `GithubSourceCredentials`, {
            accessToken: SecretValue.ssmSecure(props.githubTokenSsmParameterName, '1')
        });

        const source = codebuild.Source.gitHub({
            owner: props.owner,
            repo: props.repo,
            webhook: true
        });

        console.log(githubToken, source);
    }
}
