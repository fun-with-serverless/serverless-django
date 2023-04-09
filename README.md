[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![security: bandit](https://img.shields.io/badge/security-bandit-yellow.svg)](https://github.com/PyCQA/bandit)


<!-- PROJECT LOGO -->
<br />
<div align="center">
    <img width="256" height="256" src="https://user-images.githubusercontent.com/110536677/216813972-ea76373f-bfaa-4875-bdfa-5c93bd91acb7.png" alt="A 3d art showing whatsapp application turning into small water drops that fall">

<h3 align="center">Run Django in AWS Lambda</h3>

  <p align="center">
   This repository contains a Python Django application designed to run seamlessly inside an AWS Lambda environment, leveraging the AWS Lambda Adapter extension. The application is built to efficiently handle serverless workloads and connect to a PostgreSQL database, providing a scalable, cost-effective, and high-performance solution for modern web applications. By using the AWS Lambda Adapter, the Django app can utilize the event-driven nature of Lambda while maintaining its traditional web application structure.
    </p>
    <img src="https://user-images.githubusercontent.com/110536677/226422476-7d097813-a0c8-4c74-95a1-f9cfeae1f5ef.png" width="75%" height="75%">
    <br />
    <br />
    <a href="https://github.com/aws-hebrew-book/reminders/issues">Report Bug</a>
    ·
    <a href="https://github.com/aws-hebrew-book/reminders/issues">Request Feature</a>
  </p>
</div>


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#high-level-architecture">High level architecture</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

## High level architecture

<div align="center">
    <img src="https://user-images.githubusercontent.com/110536677/226752349-537fcb3d-1d37-4161-b502-b0e83d49c2cc.png" alt="Architecture diagram">
</div>



## Getting started
### Prerequisites
* Make sure you have [AWS SAM](https://aws.amazon.com/serverless/sam/) installed
* An AWS enviornment.
* Python 3.9 (I highly recommend using [pyenv](https://github.com/pyenv/pyenv#installation)).
* [Python Poetry](https://python-poetry.org/docs/#installation)
* Add [Poe the Poet](https://github.com/nat-n/poethepoet) to Poetry by running `poetry self add 'poethepoet[poetry_plugin]'`


### Installation
* Clone this repository.
* The application uses AWS SAM as IaC framework. 
* Run `poetry install` to install relevant dependencies.
* Run `sam build` and then `sam deploy --guided`. You can use the defaults, the only choice you have to take is the [KeyPair name](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#KeyPairs:).
* When the installation is complete you should get the Lambda endpoint URL and the bastion's machone host.




## Usage
After configuring the OpenAI and WhatsApp integration, the application will begin to collect a list of available groups associated with your WhatsApp account. These available groups can be viewed under the Groups Configuration tab, as shown in the image below:![image](https://user-images.githubusercontent.com/110536677/226162191-2480bfd4-465c-46f9-ba99-3b6eb29a2840.png)

For each group, you have the option to define whether you want it to be summarized and, if so, where you want the summary to be sent. You have three options to choose from:
* Myself - The summary messages will be sent to your own chat. This is a good option if you want to keep the summary private. ![image](https://user-images.githubusercontent.com/110536677/226162322-bf763d65-79ae-4a0d-91cf-e27cd3922669.png).
* Original Group - The summary will be written in the original group where the discussion occurred.
* None - This option will stop the daily summary for that specific group. This is the default for all new groups.

Once you've chosen where to send the summary, you can select the language in which the summary will be written. Currently, the application supports eight languages:
* English - the default
* Hebrew
* Mandarin Chinese
* Spanish
* Hindi
* Arabic
* French
* German

![image](https://user-images.githubusercontent.com/110536677/226162512-837f0eaf-8f43-4bbc-881f-16b81f10abf0.png)


## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Running the app locally
* The application use `docker-compose` to run the application locally.
* Run `docker-compose up` and you are good to go.


<!-- LICENSE -->
## License

Distributed under the Apache License Version 2.0 License. See `LICENSE` for more information.

<!-- CONTACT -->
## Contact

Efi Merdler-Kravitz - [@TServerless](https://twitter.com/TServerless)



<p align="right">(<a href="#readme-top">back to top</a>)</p>

