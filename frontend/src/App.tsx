import Resume from './components/Resume'
import ViewerCount from './components/ViewerCount'

function App() {
  return (
    <>
      <Resume>
        <Resume.Name>Eric Tran</Resume.Name>
        <Resume.Topic label="Skills">
          <p>JavaScript</p>
        </Resume.Topic>
        <Resume.Topic label="Certifications">
          <Resume.Subtopic
            label="AWS Certified Solutions Architect -- Professional"
            link="https://cp.certmetrics.com/amazon/en/public/verify/credential/7022718eda474cc9979d9e4a72418a16"
            dateFrom="Oct 2025" />
          <Resume.Subtopic
            label="AWS Certified Developer -- Associate"
            link="https://cp.certmetrics.com/amazon/en/public/verify/credential/7fe7706b4c824644b714661cc302e05c"
            dateFrom="Aug 2025" />
        </Resume.Topic>
        <Resume.Topic label="Projects">
          <Resume.Subtopic
            label="The Cloud Resume Challenge - this website!"
            dateFrom="Oct 2025">
            <p>hello there</p>
          </Resume.Subtopic>
        </Resume.Topic>
        <Resume.Topic label="Work Experience">
          <p>Software engineer, web developer, cloud enthusiast.</p>
        </Resume.Topic>
        <Resume.Topic label="Education">
          <p>Software engineer, web developer, cloud enthusiast.</p>
          <p>Software engineer, web developer, cloud enthusiast.</p>
          <p>Software engineer, web developer, cloud enthusiast.</p>
          <p>Software engineer, web developer, cloud enthusiast.</p>
          <p>Software engineer, web developer, cloud enthusiast.</p>
          <p>Software engineer, web developer, cloud enthusiast.</p>
          <p>Software engineer, web developer, cloud enthusiast.</p>
          <p>Software engineer, web developer, cloud enthusiast.</p>
        </Resume.Topic>
      </Resume>
      <ViewerCount />
    </>
  )
}

export default App
