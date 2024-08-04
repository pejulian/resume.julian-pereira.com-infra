#!/usr/bin/env node
import 'source-map-support/register';
import { App, Tags } from 'aws-cdk-lib';
import {
    ResumeJulianPereiraComInfraStack,
    ResumeJulianPereiraComInfraStackProps
} from '../lib/resume.julian-pereira.com-infra-stack.js';

const tryGetContext = <T, R extends boolean>(
    app: App,
    key: string,
    required: R
): R extends true ? T : T | undefined => {
    const value = app.node.tryGetContext(key);
    if (required && !value) {
        throw new Error(`The context value ${key} is required!`);
    }
    return value as T;
};

const app = new App();

const account = tryGetContext<string, true>(app, 'account', true);
const region = tryGetContext<string, false>(app, 'region', false);
const githubTokenSsmParameterName = tryGetContext<string, true>(app, 'githubTokenSsmParameterName', true);
const owner = tryGetContext<string, true>(app, 'owner', true);
const repo = tryGetContext<string, true>(app, 'repo', true);

const env: ResumeJulianPereiraComInfraStackProps['env'] = {
    account,
    region: region ?? 'us-east-1'
};

const stack = new ResumeJulianPereiraComInfraStack(app, 'ResumeJulianPereiraComInfraStack', {
    owner,
    repo,
    githubTokenSsmParameterName,
    env
});

Tags.of(stack).add('project', 'resume.julian-pereira.com');
Tags.of(stack).add('owner', 'Julian Pereira');
