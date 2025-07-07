import React, { useState } from 'react'


const Home: React.FC = () => {
  const [count, setCount] = useState(0)
  
  

  

  return (
    <div className="home-container">
      <div className="hero">
        <h1 className="hero-title">
          Welcome to testing-again
        </h1>
        <p className="hero-subtitle">
          get rekt big boi
        </p>
        
        <div className="demo-section">
          <div className="card">
            <h2 className="card-title">
              Interactive Demo
            </h2>
            <div className="demo-content">
              <p className="demo-description">
                Click the button below to test the React state management:
              </p>
              <button
                onClick={() => setCount(count + 1)}
                className="btn btn-primary"
              >
                Count: {count}
              </button>
            </div>
          </div>

          

          <div className="card">
            <h2 className="card-title">
              Features Enabled
            </h2>
            <div className="features-grid">
              
              <div className="feature-item">
                <span className="feature-icon">✓</span>
                <span className="feature-text">TypeScript</span>
              </div>
              
              
              
              
              
              
              
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Home
