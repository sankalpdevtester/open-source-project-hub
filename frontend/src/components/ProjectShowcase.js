import React, { useState, useEffect } from 'react';
import axios from 'axios';

function ProjectShowcase({ projectId }) {
  const [project, setProject] = useState({});

  useEffect(() => {
    axios.get(`/projects/${projectId}`)
      .then(response => {
        setProject(response.data);
      })
      .catch(error => {
        console.error(error);
      });
  }, [projectId]);

  return (
    <div>
      <h2>{project.name}</h2>
      <p>{project.description}</p>
      <p><a href={project.url}>{project.url}</a></p>
      <p>Submitted by {project.user.name}</p>
    </div>
  );
}

export default ProjectShowcase;